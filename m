Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXCPTWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXCPTWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXCPTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:22:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXCPTWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:22:43 -0400
Message-ID: <45FAEE7F.4010908@redhat.com>
Date: Fri, 16 Mar 2007 15:22:39 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Osterlund <petero2@telia.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve error recovery in serial mouse driver
References: <m3k5xiqput.fsf@telia.com>
In-Reply-To: <m3k5xiqput.fsf@telia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Osterlund wrote:
>  	if (data & 0x40) sermouse->count = 0;
> +	else if (sermouse->count == 0) return;

	if (data & 0x40)
		sermouse->count = 0;
	else
		if (sermouse->count == 0)
			return;


?

Would have been a good time to clean that one up...

