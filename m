Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYBEHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYBEHOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYBEHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:14:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:39992 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbYBEHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mt8pHK2eClzBhXMqZkb5Xi89LPc5tqDNxrh3a9AYeUOJBKM9ln8YG3ye2kGZSdMhYJwJlZUUNEt9IWPssHKiX0Kw91kY+PrbZLHVaZ0Ps/jr5JffTsWb2JahtHV7/EAa1xuom1u/Vx5AvD+36MxX6WeASz2ORGiIbIjb7vhTsLw=
Message-ID: <e2e108260802042314p572909f3se1f58016cc20df14@mail.gmail.com>
Date: Tue, 5 Feb 2008 08:14:37 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] LIO Target iSCSI/SE PS3-Linux / FC8 builds
Cc: "Marc Dietrich" <Marc.Dietrich@ap.physik.uni-giessen.de>,
       cbe-oss-dev@ozlabs.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Open iSCSI" <open-iscsi@googlegroups.com>
In-Reply-To: <200802041744.55909.marc.dietrich@ap.physik.uni-giessen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202134623.11265.524.camel@haakon2.linux-iscsi.org>
	 <200802041647.06234.marc.dietrich@ap.physik.uni-giessen.de>
	 <1202140360.11265.543.camel@haakon2.linux-iscsi.org>
	 <200802041744.55909.marc.dietrich@ap.physik.uni-giessen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 5:44 PM, Marc Dietrich
<Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> ...
> Anyway, heres a quick ugly fix for the ARCH detection code, tested on ps3.
> ...

Architecture detection is indeed broken in LIO. Would it be possible
to use the standard config.guess script instead of the custom LIO arch
detection script ? config.guess is included with a.o. automake and
libtool.

Bart Van Assche.
