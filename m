Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854Ab0AUSKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0AUSKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 13:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809Ab0AUSJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 13:09:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab0AUSJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 13:09:59 -0500
Message-ID: <4B589839.7050801@zytor.com>
Date: Thu, 21 Jan 2010 10:08:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] x86, smp: Convert msr-smp.c to an smp library
References: <1264092093-13739-1-git-send-email-bp@amd64.org> <1264092093-13739-2-git-send-email-bp@amd64.org>
In-Reply-To: <1264092093-13739-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 08:41 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Put all smp-related helpers into lib/smp.c to use for the rest of the
> kernel.
> 

NAK.  It's better to have more and smaller source files rather than
fewer and larger.  Create a new file for the wbinvd helpers.

	-hpa
