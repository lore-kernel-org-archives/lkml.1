Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXIETtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXIETtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbXIETtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:49:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:11475 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXIETtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dklPzvAKyseLH03wDA+tGimX8dxIFAfJF45WIpua7IEtb5apXT7opa2DAXRjYTYM9X8TyZhc72NeXJeTtgtws3b68VTAnXLgpDKFmVOFMXp9RnIxlbKkqkj56Ru/vY++gKlpdjl0nblsx8WePwAhVuni9GMh71SfI0eky8CK5PQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 20:49:29 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709052014.12653.vda.linux@googlemail.com> <1189019235.4442.27.camel@imap.mvista.com>
In-Reply-To: <1189019235.4442.27.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709052049.30649.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 20:07, Daniel Walker wrote:
> On Wed, 2007-09-05 at 20:14 +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > > > You version doesn't work with CONFIG_MODULES right?
> > > > 
> > > > It works with CONFIG_MODULES.
> > > 
> > > Really? Take a look at this version,
> > > 
> > > http://lkml.org/lkml/2006/6/4/169
> > > 
> > > Marcello had to implement a two pass build to add back symbol used in
> > > modules which got removed from the main kernel.. You don't appear to do
> > > that. Marcelo also claims better size reduction than you.
> > 
> > This will discard EXPORT_SYMBOLs potentially used by
> > out-of-tree modules.
> 
> Right, so it doesn't work with modules..

What does "it" stand for in this sentence?

My patch was tested to work in my limited testing,
but it is very conservative.

I can't talk for Marcelo, but his patch probably worked too,
it just didn't guarantee that you can install kernel, and
then compile and load external module. Wel, it will compile,
but maybe will fail to load.

It sounds like *in-tree modules* were loading
just fine for Marcelo.
--
vda
