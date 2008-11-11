Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYKKIWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYKKIWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYKKIWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:22:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:21102 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYKKIWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:22:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tyA8FU292PsBgt8Hr6d2FCcO1oWHt72YjP2Bq5joiFPbwGHw2N1bl5speQXSupKaHn
         i/qT4jw/ssOG5QDaIVTBchpXKxg6hRLnKd0twrM4YCX1Zcek87H3fz0/gd+i/Aawa/SC
         LPvcX2XOQZ66xf4mVCVMXftN6LtqZlj2QguAk=
Message-ID: <af0faace0811110022j161d4e26h87f2d9624b9fa494@mail.gmail.com>
Date: Tue, 11 Nov 2008 16:22:39 +0800
From: "Pan ruochen" <panruochen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How kernel applies LRU to swap out physical pages?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I'm reading the linux kernel 2.6.14. But can't understand how LRU algorithm
is applied to page swapping. what is the 'USED' of LRU referred to? The
reference counter which the page is mapped by processes, or the frequency that
CPU reads/writes in the page. In common sense, the LRU algorithm will be more
optimal for the second case. But it depends on CPU capability.
I will be very appreciated if somebody can explain that in details.

-------------
Best Regards,
PRC
Nov 11, 2008
