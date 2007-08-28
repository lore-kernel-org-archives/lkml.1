Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbXH1Tzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbXH1Tzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXH1TzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:55:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9757 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbXH1TzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f8RvNvU9Ooyx0BOBrIMHrfM4FOspjMi+rfSTbx7Z82c9qEhlq+fQCffi1SU17AcpzxClcRxu1jy4YP/0nMOYnKjCxvxdC7l2WJACEWB7wi3WgYK1HjJNRB+sPIvYk5lw5RsI3qmYiH8HmY00eZoJvXHVN0R40EObLmBB6ADDM9w=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Tue, 28 Aug 2007 20:55:06 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
References: <200708252257.07241.vda.linux@googlemail.com> <200708281256.35162.vda.linux@googlemail.com> <20070828081710.4687185c@laptopd505.fenrus.org>
In-Reply-To: <20070828081710.4687185c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708282055.07411.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 16:17, Arjan van de Ven wrote:
> On Tue, 28 Aug 2007 12:56:34 +010
>
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > >   make namespacecheck
> >
> > Thanks, nice tool.
> >
> > aic7xxx is kind of not very nice in this regard.
> >
> > See below what I get even on non-patched driver.
> >
> > I am willing to clean it up, but I still would like
> > "debloating" patch to be accepted.
>
> Fwiw I do like your debloat patch a lot; it's just only half the
> equation ... if you also do the namespace fixes, I bet the driver
> debloats even more...

Yes, I know, and I am happy to do that too. I just don't know
whether patches will be accepted.

Why this patch is not commented on by scsi people?
Am I sending patches to wrong people/lists?
--
vda
