Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYHLUt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYHLUt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHLUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:48:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:12796 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYHLUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=af0VGRQ5m6Ict74OgCarxoTXlNBvyz8QZ2xn/IaIDHaOp3FgORkdeEvEtV+uvCJGTC
         erEwoZyWsa2hCBPYoCAddCHfI3rZ2g4sN142UlZmMYIBa7vwR5jQGbKVhkIzG8OKnaPL
         cLx82VmdHW9HzPJeYKRBylzW4+qW6UReJ1++c=
Message-ID: <48A1F734.7040801@gmail.com>
Date: Tue, 12 Aug 2008 22:48:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: iwl + iomap + readl/writel
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spotted that iwl drivers use readl method on an iomap space. IIRC some archs 
might return a tag instead of an address expected by readl/writel.

I think you should either switch to ioread32/iowrite32 or to ioremap.
