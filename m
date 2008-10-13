Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYJMS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYJMS6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYJMS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:58:45 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:58511 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbYJMS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OIrbscnvRNPGf/dUW4eaC7vRNPU7E8RRmUxFqdChs3hTuclIv4VMXys00fDBKVEmUS
         fXYMHvHNkV4P2Gjawp9YJzhOvs11jM3UMpyYHUUdHkWC+Lb0m09V+aoy1NNTEssCJcPh
         isQ+bvAFurch4CQwDqJIPEG1acl9gf6TR2zUY=
Message-ID: <912ec82a0810131158o316201a5o803cb46c67c1b065@mail.gmail.com>
Date: Mon, 13 Oct 2008 20:58:43 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: section mismatch with a platform driver
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48F377F4.7070502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
	 <20081013090133.a58116a2.randy.dunlap@oracle.com>
	 <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>
	 <48F377F4.7070502@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 6:31 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Does that mean that all drivers with __init in their probe functions are bogus ?
>
> It depends.  If your platform doesn't support hotplug, then it's possible
> that the probe function is only called during system init, so it would be OK.

Hmm any idea then why did it give me a section mismatch warning ?

Thanks!!
