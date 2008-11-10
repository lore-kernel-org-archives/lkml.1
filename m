Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYKJLrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYKJLrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 06:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYKJLrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 06:47:16 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:53259 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYKJLrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HqmSS+FrfuTz4zlvrabI6sLZI1SXLljACIovtpfv25KfZpCuDvKP3fdsAez2pHwTyK
         SNb2SgIoLmBk913wI1Np9Jp7Vmaiexk6ul4ga3PqLsen8m3TOggzf6InKMawHgYKci86
         Mqrd8Pzjvl1oDySMkfMkCbtTLA8EKZoXoScfI=
Message-ID: <b0438a630811100347s2d228f2cu26610f7279eb083f@mail.gmail.com>
Date: Mon, 10 Nov 2008 12:47:14 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: EHCI "on the go"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Due to some problems with the EHCI in an IXP465, I have found that
this micro has an "on the go" feature. One of its features seems to be
an "Embedded Transaction Translator", that seems to be quite
"propietary".

I see in ehci.h, that using CONFIG_USB_EHCI_ROOT_HUB_TT, a function
called "ehci_port_speed" has been added, and the comments suggest to
implement the particularities of each controller with other functions.

The question is:
- Are there many different implementations (it seems there are not,
because I cannot see code for each of them... unless they are so
particular that they do not even use the general interface)?
- Is there any place comparing the similarities / differences between them?

Thanks

Miguel Ángel Álvarez
