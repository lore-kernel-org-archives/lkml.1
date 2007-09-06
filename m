Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbXIFK6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbXIFK6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXIFK54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:57:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:24885 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXIFK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NYw4BKEyTHRfGb1R9ncCE3kC0shEHUHxZGpIvwnf3qAkjHhOpjByh70HIA9PSd5HEXWhEiqgb5G4qUHUiA2TQt/U8ByyfPaFUvKm0o9dtCp9O1BSh9+HKc2Va3S6huJcqm4VxphjHfk2t0PbN7bwhXeA1SQyPlTwV33BEcCe+WI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 11:57:43 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709052049.30649.vda.linux@googlemail.com> <1189021619.4442.36.camel@imap.mvista.com>
In-Reply-To: <1189021619.4442.36.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061157.44080.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 20:46, Daniel Walker wrote:
> On Wed, 2007-09-05 at 20:49 +0100, Denys Vlasenko wrote:
> 
> > What does "it" stand for in this sentence?
> 
> "it" is your patches, and I think we got to bottom of it .. "it" (i.e.
> your patches) don't actually work with modules, which is what you
> originally contended ..

Kernel builds, loads and runs with my patches, and modules load just fine.

> > My patch was tested to work in my limited testing,
> > but it is very conservative.
> > 
> > I can't talk for Marcelo, but his patch probably worked too,
> > it just didn't guarantee that you can install kernel, and
> > then compile and load external module. Wel, it will compile,
> > but maybe will fail to load.
> 
> At least you should modify your Kconfig changes so that you don't allow
> people to select your new option unless they have CONFIG_MODULES off..

You seem to have interesting definition of "desn't work".
--
vda
