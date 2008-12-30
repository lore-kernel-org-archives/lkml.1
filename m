Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYL3Mni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYL3Mni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYL3Mna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:43:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:9041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYL3Mn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:43:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GeU+E8xF2GKVDRG/YMeWSfDCUKxUkXM+9fIBuZ+uZZMlFWXlUxNzGubyBnuJe5Ha74
         zkfMlBNJ1F/SJhNlGSFNx6uQpzkmmJppvlN8n9U+8dvMWemFyyqQQW5xP8cgMaSKtgCS
         h0FJr1dgRQlryZ8POXGYpC4g+GwZvgj7HAWwM=
Message-ID: <164c42ea0812300443m6d034108h56ca71c86e52a641@mail.gmail.com>
Date: Tue, 30 Dec 2008 13:43:27 +0100
From: "Per Andreas Gulbrandsen" <theperan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about several drivers for one physical device
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have two drivers that both use the same device, an FPGA connected
via pci. These two pci drivers represent different functionality in
the FPGA, and they each have it's own BAR. My problem is that I can't
get these two drivers to correctly initialize. Only the first one
loaded actually finds the device (which one of the two doesn't
matter). The second driver I load never has it's probe method run, and
so it doesn't initialize correctly. I am aware that integrating these
two drivers in one module is a possiblity, but since these two drivers
aren't really related (except that they both drive an FPGA) I would
like to keep them as two separate modules. My question is really: Is
there another way to do this, or will I have to integrate the two so
they share init/exit/probe methods?

--
mvh
Per Andreas Gulbrandsen
