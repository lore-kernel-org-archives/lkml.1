Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYLVCVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYLVCVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 21:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYLVCVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 21:21:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:56449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYLVCVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 21:21:33 -0500
Message-ID: <494EF9A1.90002@kernel.org>
Date: Mon, 22 Dec 2008 11:21:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Badalian Vyacheslav <slavon@bigtelecom.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Red leds at harddisk bays on SR1530HSH after update to 2.6.27.x
References: <494A34CA.9030906@bigtelecom.ru> <20081219223246.b0aea84d.akpm@linux-foundation.org>
In-Reply-To: <20081219223246.b0aea84d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Dec 2008 02:21:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide)
> 
> On Thu, 18 Dec 2008 14:32:26 +0300 Badalian Vyacheslav <slavon@bigtelecom.ru> wrote:
> 
>> Hello all.
>> After update from 2.6.26 to 2.6.27 all leds at drive bays now red.
>> SATA controller in AHCI mode.
>> Platform is Intel SR1530HSH
>>
>> Config attached.
>>
>> Any patches for test? Any ideas? Any other info needed? Or i must go to
>> bugtracker? ;)

Does ahci.ahci_em_messages=0 help?

-- 
tejun
