Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYA2Hjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYA2Hjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 02:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYA2Hjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 02:39:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:44090 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYA2Hjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 02:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LcSkQONNDVvduhXB/4Y5V3eZ8MpwGKCZo2pqM1k9VcZnCCtAc4if51RO8HnxJihLxuI3p4oMKbLUHSR1CGj1YPqIS/yCmmBWLuaAE2nygqd0wkpAhhEoab+2HXlzt6bSiDIYEFTsqzbcGYs/0ZM1O/LSY+MNunQZKnHiuqWGGX0=
Message-ID: <86802c440801282339q77a585f5h82df44295ddfb6fd@mail.gmail.com>
Date: Mon, 28 Jan 2008 23:39:30 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c II
Cc: "Joachim Deguara" <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       "Dean Roe" <roe@cray.com>
In-Reply-To: <20080129080927.GA1414@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801281211.28214.joachim.deguara@amd.com>
	 <p73y7a970nd.fsf@bingen.suse.de>
	 <200801282012.47190.yinghai.lu@sun.com>
	 <20080129045659.GA31847@one.firstfloor.org>
	 <20080129080927.GA1414@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 12:09 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > SRAT is essentially just a two dimensional table with node distances.
>
> Sorry, that was actually SLIT. SRAT is not two dimensional, but also
> relatively simple. SLIT you don't really need to implement.
>

need to add some CONFIG option to parse SRAT, MADT etc only. but don't
pull DSDT related...

YH
