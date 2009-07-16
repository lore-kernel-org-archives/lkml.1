Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZGPBJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZGPBJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZGPBJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:09:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:33849 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZGPBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:09:23 -0400
Date: Wed, 15 Jul 2009 18:09:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: deterministic scsi order with async scan 
Message-ID: <alpine.DEB.1.10.0907151801040.9159@asgard>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is there any way to get deterministic device ordering with scsi async 
scanning?

currently (2.6.30) it seems that the various scsi busses are loaded in the 
order that they are detected, which can vary from boot to boot depending 
on how long it takes for the card to initialize.

would it be possible to detect the cards/drives, but not register them 
until all the detection is complete so that they can be registered in a 
deterministic order?

having two drives on two different controllers swap positions from boot to 
boot makes it very painful. yes I can make an initrd that fixes this up in 
user space by examining each drive and creating links to re-order them, 
but this is a lot of work to fix randomization that can be prevented in 
the first place.

David Lang
