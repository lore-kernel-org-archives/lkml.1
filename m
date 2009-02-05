Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZBETal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZBETal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZBETac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:30:32 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:38468 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZBETab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lhawbqTkoqxwFl+mfhekD4bOOksdj8BMUuQS43zDL0U6eQ1vrQAcY0JMzkfjfHgIW/
         MjTM6RdTvirmJDsZOAj0+3iCnpVhs2WGYMQKXCY9ftsuroVd0/BCh7QE8O3uvguij8X+
         HTwpmNp9q6gXQvk5QbjZ/FuBqCHfhVaJUaa1A=
Subject: Re: [PATCH] 9p: fix endian issues [attempt 2]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <a4e6962a0902051116r1921e976idd8f820568d40bd5@mail.gmail.com>
References: <1233860727-16884-1-git-send-email-ericvh@gmail.com>
	 <1233861023.22037.0.camel@brick>
	 <a4e6962a0902051116r1921e976idd8f820568d40bd5@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 11:30:27 -0800
Message-Id: <1233862227.22037.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 13:16 -0600, Eric Van Hensbergen wrote:
> On Thu, Feb 5, 2009 at 1:10 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > On Thu, 2009-02-05 at 13:05 -0600, ericvh@gmail.com wrote:
> >> From: Eric Van Hensbergen <ericvh@gmail.com>
> >>
> >> When the changes were done to the protocol last release, some endian
> >> bugs crept in.  This patch fixes those endian problems and has been
> >> verified to run on 32/64 bit and x86/ppc architectures.
> >>
> >> This version of the patch incorporates the correct annotations
> >> for endian variables.
> >>
> >> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> >
> > Looks better to me.
> >
> 
> Thanks for your help.  Unfortunately, I was trigger happy with the
> commit and added whitespace, so everyone gets to see this patch one
> more time (sorry).
> 

Actually for the read case, you may want to look at leXX_to_cpus which
will swap the value in-place through a pointer, so you can avoid the
temporary endian variable.


Harvey

