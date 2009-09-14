Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZINLgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZINLgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZINLf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:35:59 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62011 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZINLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=H8uy1ZbJkUDRc6vYT4bv/F5p8GEK93wwBkXUCyvrVIZ3Kc+1R3WO0JJHYQ3VFEu8Mp
         7WQHOxPo5pJ+KX0F3mAkmhUKG2s5HEMWre8khXD2CsCMIaLjLIgHlf7tZYxe/vZgBJDX
         GTndHOaTys1Ny3VFvA2BRUBrHUTsu3YLp05FU=
From: Eric Lacombe <goretux@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Eliminating kernel mixed page (code + data)
Date: Mon, 14 Sep 2009 13:35:44 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.28-15-generic; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Eric Lacombe <eric.lacombe@security-labs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909141335.44313.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First, is there a kernel option to enforce kernel code and kernel data 
separation among pages ?

Otherwise, is it sufficient to enforce page alignment for the start address of 
all data segment, to achieve this goal ?
(on top of using CONFIG_RELOCATABLE)

Thanks in advance for your answer,

	Eric
