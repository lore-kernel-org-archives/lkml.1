Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbYE0Vvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbYE0Vvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbYE0Vvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:51:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:33276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbYE0Vvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lOEIyBX6/PfJ5R8my1zgkSvYEsXtLD09stXAq66M4v6GTd4wbzRJr4e0vucqk2OBLsmmlbm/YfEha43xKlxhJZG+tx8UVARpWBZXErNTw+fxS1hLIXEyu7uEum2CW0TgrBCpBs5cg1KDkxmJs8DLzlnZGn1uUURz5oBG1ruQFpk=
Message-ID: <e38d12ff0805271451w5466aacbu3f2a7eeb13e7004b@mail.gmail.com>
Date: Tue, 27 May 2008 17:51:31 -0400
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: rt10 on top of grsecurity-2.1.11: issue with marker-upstream.patch
Cc: mingo@elite.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version is 2.6.24.7
When merging grsecurity into mainline, it replaces these members in
struct module: module_init and init_size and replaces them with
module_init_rw, module_init_rx, init_size_rw and init_size_rx
Should imv_unref() inside kernel/modules.c use the rw or rx values (or both) ?
-- 
Andrey Vul
