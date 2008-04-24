Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYDXM1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYDXM1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYDXM07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:26:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57114 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbYDXM06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:26:58 -0400
Date: Thu, 24 Apr 2008 07:26:54 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       jmorris@namei.org
Subject: Re: [PATCH 1/4] capability: capability.h whitespace, syntax, and
	other cleanups
Message-ID: <20080424122654.GA8292@sergelap.austin.ibm.com>
References: <12089731541206-git-send-email-eparis@redhat.com> <20080424015416.GA13904@sergelap.austin.ibm.com> <1209039236.2985.127.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209039236.2985.127.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Wed, 2008-04-23 at 20:54 -0500, Serge E. Hallyn wrote:
> > Quoting eparis@redhat.com (eparis@redhat.com):
> > > From: Eric Paris <eparis@redhat.com>
> > > 
> > > This patch changes capability.h to fix whitespace and syntax issues.  Things that
> > > are fixed may include (does not not have to include)
> > > 
> > > whitespace at end of lines
> > > spaces followed by tabs
> > > spaces used instead of tabs
> > > spacing around parenthesis
> > > location of { around structs and else clauses
> > > location of * in pointer declarations
> > > removal of initialization of static data to keep it in the right section
> > > useless {} in if statemetns
> > > useless checking for NULL before kfree
> > > fixing of the indentation depth of switch statements
> > > no assignments in if statements
> > > include spaces around , in function calls
> > > and any number of other things I forgot to mention
> > 
> > Thanks.  Looks fine other than the inexplicable (afaics)
> > jumping of the capability #s by one tab for CAP_NET_ADMIN
> > and then again from CAP_IPC_OWNER on.
> 
> It just looks that way in the patch for things whose names are exactly
> that long because of the + at the beginning of the line pushing them
> over a tab column in your mailer.  They are correct after the patch
> applies.
> 
> > Hmm, well you also made some odd (inconsistent) tab+space choices at and
> > following cap_clear.
> 
> Same thing.  And I'll admit that it is a bit inconsistent, but a whole
> new tab just pushed things too far to the right and I didn't want to
> leave 8 spaces anywhere in the file.   So that's what I came up with...
> I promise it looks nice in the end   :)

Okay, sounds good - something needed to be done about those files in any
case.  Thanks for doing that.

-serge
