Return-Path: <linux-kernel-owner+w=401wt.eu-S934978AbXHORy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978AbXHORy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764106AbXHORyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:54:16 -0400
Received: from web52510.mail.re2.yahoo.com ([206.190.48.193]:23873 "HELO
	web52510.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763651AbXHORyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:54:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tZLfOoY468KrtnjBdytv2JLOYZn3eorsaPdYy04EyHGRAw5H/V9D3Q69hASa29As1iJIdc+oAZ0kTwt3nTyniQMdXexxQt6ka7Xd/pLdrmcQKBAFP5GclInVL2DqNKGaUVDm5MMghcaezuQQ05Hd/9SNdNgGZw1E8eWoTDf50Ek=;
X-YMail-OSG: IVUFoSQVM1lOgjcWaHwylI8uD8D_P5r9UGh6XSyX6yWMxuQjKEobIyJomlFjRevZlVq9ZLvVu4wiY5KYNxuw3jw9xL.fnYpRO8A3C2K9lhisuAN7BeqyJGNZw2ypW8XD2iiVcxVfXEf4n_c-
Date: Wed, 15 Aug 2007 10:54:13 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Phillip Susi <psusi@cfl.rr.com>, Kyle Moffett <mrmacman_g4@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <46C33934.7060802@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <579287.76409.qm@web52510.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Phillip Susi <psusi@cfl.rr.com> wrote:

> Kyle Moffett wrote:
> > Going even further in this direction, the
> following POSIX ACL on the 
> > directories will do what you want:
> > 
> > ## Note: file owner and group are kmoffett
> > u::rw-
> > g::rw-
> > u:lsorens:rw-
> > u:mtharp:rw-
> > u:mperkel:rw-
> > g:randomcvsdudes:r-
> > default:u::rw-
> > default:g::rw-
> > default:u:lsorens
> > default:u:mtharp:rw-
> > default:u:mperkel:rw-
> > default:g:randomcvsdudes:r-
> 
> 
> The problem that I have with this setup is that it
> specifies an ACL on 
> EACH file.  Yes, you can set a default on the
> directory for newly 
> created files, but what if I want to add a user to
> the access list for 
> that whole directory?  I have to individually update
> every acl on every 
> file in that directory.  Also if you move a file
> created elsewhere into 
> that directory, it retains its existing permissions
> doesn't it?  I would 
> rather just add a new ace to the directory itself
> which specifies that 
> it applies to the entire tree.  Then you only need
> to store a single acl 
> on disk, and only have to update one acl to add a
> new user.
> 
> 


In the model I'm suggesting files and directories no
longer have permissions so ACLs go away. Only users,
groups, managers, applications, and other objects have
permissions.

So if you move a file into the tree then everything
that has permission to that tree has rights to the
file.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  
