Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXHORan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXHORan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbXHORa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:30:26 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:43744 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933988AbXHORaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:30:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yDkNRLT/yLxSre0BRTzxB5hA6AMoZ0+5P1MfyJhX4r7Se9Y4TRVxhsf9PyWYXUo/kJNc434DAKVi+TB1cUkJTVNEdZm0JRxEwWSQy4MU6hj1rm0vj+vBPDz3o/A4tgjZnPYWlU6ygUFEFTp2S4N/vY5NiSu/3kAS0IQx7hwyR4c=;
X-YMail-OSG: C9.ntbIVM1ktintSNJvDcVux2HNrjJ_KAeqSZaZ9Qzmsi9CuJ8pB.uG5BrVnIhceVQ--
Date: Wed, 15 Aug 2007 10:30:19 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <152F34EE-58BE-43BE-9E33-597F2AE1DFAA@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <767509.60425.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:
.
> 
> > The important point here is that directories don't
> really exist.
> 
> Except they do, and without directories the
> performance of your  
> average filesystem is going to suck.
> 

Actually you would get a speed improvement. You hash
the full name and get the file number. You don't have
to break up the name into sections except for
evaluating name permissions.

The important concept here is that files and name
aren't stored by levels of directories. The name
points to the file number. Directory levels are
emulated based on name separation characters or any
other algorithm that you want to use.

One could create a file system and permission system
that gets rid of the concept of directories entirely
if one chooses to.

That's outside the box big time.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


