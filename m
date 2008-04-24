Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYDXMPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYDXMPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYDXMPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:15:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYDXMPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:15:08 -0400
Subject: Re: [PATCH 1/4] capability: capability.h whitespace, syntax, and
	other cleanups
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
In-Reply-To: <20080424015416.GA13904@sergelap.austin.ibm.com>
References: <12089731541206-git-send-email-eparis@redhat.com>
	 <20080424015416.GA13904@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 08:13:56 -0400
Message-Id: <1209039236.2985.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 20:54 -0500, Serge E. Hallyn wrote:
> Quoting eparis@redhat.com (eparis@redhat.com):
> > From: Eric Paris <eparis@redhat.com>
> > 
> > This patch changes capability.h to fix whitespace and syntax issues.  Things that
> > are fixed may include (does not not have to include)
> > 
> > whitespace at end of lines
> > spaces followed by tabs
> > spaces used instead of tabs
> > spacing around parenthesis
> > location of { around structs and else clauses
> > location of * in pointer declarations
> > removal of initialization of static data to keep it in the right section
> > useless {} in if statemetns
> > useless checking for NULL before kfree
> > fixing of the indentation depth of switch statements
> > no assignments in if statements
> > include spaces around , in function calls
> > and any number of other things I forgot to mention
> 
> Thanks.  Looks fine other than the inexplicable (afaics)
> jumping of the capability #s by one tab for CAP_NET_ADMIN
> and then again from CAP_IPC_OWNER on.

It just looks that way in the patch for things whose names are exactly
that long because of the + at the beginning of the line pushing them
over a tab column in your mailer.  They are correct after the patch
applies.

> Hmm, well you also made some odd (inconsistent) tab+space choices at and
> following cap_clear.

Same thing.  And I'll admit that it is a bit inconsistent, but a whole
new tab just pushed things too far to the right and I didn't want to
leave 8 spaces anywhere in the file.   So that's what I came up with...
I promise it looks nice in the end   :)

> 
> thanks,
> -serge

