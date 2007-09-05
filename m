Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXIESq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXIESq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbXIESqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:46:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46196 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbXIESqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A81RsRUyCYbfmTJ6XVTX8XfpmFyM54eK7sdddYoyxPx8Pm4ju4e51/y9VwOZQJUZ1eC4GbGyShKwepZW+0HZLet9A6+WkedCn6kiO//HN6Z6ybIcVlnkpOrCBgVLcDKOIUG8L9NwbqxuMbWlKB1KULGHOQhBZ2scwqDMpGBpqjM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 19:46:11 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <E1ISxBz-00040p-EO@flower>
In-Reply-To: <E1ISxBz-00040p-EO@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051946.12096.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 16:53, Oleg Verych wrote:
> * Wed, 5 Sep 2007 14:43:21 +0100
> * User-Agent: KMail/1.9.1
> >
> > Build system: section garbage collection for vmlinux
> 
> Maybe this is just a test suit to get finish with `make XYZ static`?

They are vaguely connected in a sense that unused function which is
not marked static doesn't generate gcc warning, but will be discarded
by --gc-sections. "make XYZ static" also tends to find them - you make
function static, you recompile the file, and gcc informs you that
the function is not used at all!

This happened to me when I did aic7xxx patches.

You may yse --print-gc-sections to see the list of discarded sections.
--
vda
