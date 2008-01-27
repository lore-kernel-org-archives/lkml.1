Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYA0UwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYA0UwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 15:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYA0Uvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 15:51:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:38590 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYA0Uvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 15:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D4pyCrQhk9yQOn12VHkxn2JHvnuOQ1CSN53QB9ZQiqyvPI4sfryK5eIjamB7aNpQlxfVukmG8U0gZQ5CLDQ9fUI03WOuPEGE5WBtGl9115lpbr+ITtx0Z+l/LG6qhDTYGM4G78oySIm29Z/EM8ubs+lSLfJ4xMYhCGdHT+lpkAQ=
Message-ID: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
Date: Sun, 27 Jan 2008 21:51:52 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about DMA
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have 2 questions regarding set_dma_addr(unsigned int channel,
unsigned int addr) helper.

1/  Why does the function take only one address ? I would expect it
to take both a source and a destination address for the dma controller
to transfer data.

2/ The type of address parameter is an unsigned int. Why isn't it a dma_addr_t
type ?

Thanks !
-- 
Francis
