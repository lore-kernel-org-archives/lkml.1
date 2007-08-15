Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbXHORCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbXHORCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764692AbXHORCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:02:32 -0400
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:27410 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759433AbXHORCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:02:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=te7hpbbR10opL6uLCgaucHoe1ZUjqUgOaSlxCLUo8EXbYINo3QVbgHrgvTYynCyn8Onk4e5yywt5h9i9841u6tHls3krC8rNCT5WUka/aDUu2tpXig2EvmY5SQtjVu4miAszrovlF8nnXS43o3BVW37/VlgSEz7wbuJhMUQCiCM=;
X-YMail-OSG: Ei98JcsVM1n_ojg8L6UFWLpycKFvr3_gYNHELgxZsUSjqrROBttCa1ZaRTLs4ZUK5WERVyob9cRSPPyQYGrHYHG7tzKynebhshW.i5BKpCaLby5bmDiVsjYItrFJUSOoC_wLZCpEoyI6A2c-
Date: Wed, 15 Aug 2007 10:02:29 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: alan <alan@clueserver.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <249938.3918.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- alan <alan@clueserver.org> wrote:

> On Tue, 14 Aug 2007, Marc Perkel wrote:
> 
> > For example. If you list a directory you only see
> the
> > files that you have some rights to and files where
> you
> > have no rights are invisible to you. If a file is
> read
> > only to you then you can't delete it either.
> Having
> > write access to a directory really means that you
> have
> > file create rights. You can also delete files that
> you
> > have write access to. You would also allocate
> > permissions to manage file rights like being able
> to
> > set the rights of inferior users.
> 
> Imagine the fun you will have trying to write a file
> name and being told 
> you cannot write it for some unknown reason. 
> Unbeknownst to you, there is 
> a file there, but it is not owned by you, thus
> invisible.
> 
> Making a file system more user oriented would avoid
> little gotchas like 
> this.  The reason it is "programmer oriented" is
> that those are the people 
> who have worked out why it works and why certain
> things are bad ideas.
>

That not a problem - it's a feature. In such a
situation the person would get a general file creation
error. Although it isn't likely people would structure
files with invisible files in directories that the
user has create permissions it is logical that if I
put a file in a place where the user has no rights I
want it to stay there. Currently the user can delete
files where they have no rights.

I might also want to restrict the kind of a user can
createor give permission to create only certian file
names.

/etc/vz/conf/*.conf - create - readonly - self-rw
/etc/vz/conf - deny 

This would allow the user to read all *.conf files,
create new *.conf files, and full permissions to
read/write/delete files that the user created but not
files that others created. If listing a directory then
only the *.conf files would appear even if other files
are in the directory.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
