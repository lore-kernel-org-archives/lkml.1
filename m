Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab0CLXgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:36:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56071 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab0CLXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:36:43 -0500
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] davinci: MMC: Pass number of SG segments as platform data
References: <1268397249-7654-1-git-send-email-sudhakar.raj@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 12 Mar 2010 15:36:35 -0800
In-Reply-To: <1268397249-7654-1-git-send-email-sudhakar.raj@ti.com> (Sudhakar Rajashekhara's message of "Fri\, 12 Mar 2010 18\:04\:09 +0530")
Message-ID: <87ljdx3yf0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudhakar Rajashekhara <sudhakar.raj@ti.com> writes:

> On some platforms like DM355, the number of EDMA parameter
> slots available for EDMA_SLOT_ANY usage are few. In such cases,
> if MMC/SD uses 16 slots for each instance of MMC controller,
> then the number of slots available for other modules will be
> very few.
>
> By passing the number of EDMA slots to be used in MMC driver
> from platform data, EDMA slots available for other purposes
> can be controlled.
>
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
