Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYAOXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYAOXol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAOXoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:44:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57851 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYAOXob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:44:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vCgcqV/2WGNT/lyI9UaD0jj3TP5cC/QiaPrAXsryFTVowjVE9O0jF41hccyPHNgw7
	O267WA1b4n6FKoWzgSLcg==
Message-ID: <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
Date: Tue, 15 Jan 2008 18:44:26 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "David Chinner" <dgc@sgi.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Theodore Tso" <tytso@mit.edu>, "Al Boldi" <a1426z@gawab.com>,
       "Valerie Henson" <val.henson@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080115230714.GC3573@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801090022.55589.a1426z@gawab.com>
	 <200801090740.12989.a1426z@gawab.com>
	 <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	 <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
	 <20080113171916.GB4132@ucw.cz>
	 <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	 <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com>
	 <20080115230714.GC3573@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 6:07 PM, Pavel Machek <pavel@ucw.cz> wrote:
> I had write cache enabled on my main computer. Oops. I guess that
> means we do need better documentation.

Writeback cache on disk in iteself is not bad, it only gets bad if the
disk is not engineered to save all its dirty cache on power loss,
using the disk motor as a generator or alternatively a small battery.
It would be awfully nice to know which brands fail here, if any,
because writeback cache is a big performance booster.

Regards,

Daniel
