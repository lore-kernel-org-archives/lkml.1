Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbXH3Qrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbXH3Qrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbXH3QrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:47:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:30997 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbXH3QrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j7cqDEtKtJr/hI/uGQkCOOEAHkZYF+K2lzArSV2z7GHLOZFbJohhBMWDX5AXcCBJH9UZdKbHbylyUmBfk3KKWA9nIrgXb0wa0Z9YBHM02vNsoToVtqC2RlkcFBd1cEAO/APIZ1uSSOZT98zkyZCRHXnc9vqQkFgGujj3OpD7Y2U=
Message-ID: <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
Date: Thu, 30 Aug 2007 09:47:19 -0700
From: "Matthew Jacob" <lydianconcepts@gmail.com>
To: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: Re: FC - NPIV in 2.6.23-rc2
Cc: "Abhishek Kane" <abhishek.kane@gmail.com>, linux-kernel@vger.kernel.org,
       linux-driver@qlogic.com, linux-scsi@vger.kernel.org
In-Reply-To: <46D6EFE7.40802@qlogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
	 <46D6EFE7.40802@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > some sought of documentation for this, please let me know.
> NPIV is a feature to provide multiple path available on one physical port and it has implemented based on the multiport ID (MID) capability on the switch.
> So, you have to have the switch with MID capable on the configuration to support NPIV, besides the controller.
>

No, if the switch doesn't suport NP-IV, the 24XX f/w will come up in
Public Loop mode (FL).
