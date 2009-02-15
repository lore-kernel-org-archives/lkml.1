Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZBOXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZBOXVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZBOXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:21:39 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:37780 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651AbZBOXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:21:38 -0500
Message-ID: <4998A37D.3040904@ru.mvista.com>
Date: Mon, 16 Feb 2009 02:21:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] ide: use ->tf_read in ide_read_error()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213458.13202.77992.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213458.13202.77992.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Add IDE_TFLAG_IN_FEATURE taskfile flag for reading Feature
>   register and handle it in ->tf_read.
>   

  Doesn't seem like a good name -- you can't read the features register. 
I should've commented to this patch earlier, of course...

MBR, Sergei


