Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZCIQrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZCIQrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZCIQqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:46:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:42579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZCIQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:46:53 -0400
Cc: panto@intracom.gr, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <18D6DC29-CCBB-4221-A0B2-64D0555EB8E2@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Xiaotian Feng <Xiaotian.Feng@windriver.com>
In-Reply-To: <1236308483-20495-1-git-send-email-Xiaotian.Feng@windriver.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] cpm_uart: fix non-console port startup bug
Date: Mon, 9 Mar 2009 11:46:41 -0500
References: <1236308483-20495-1-git-send-email-Xiaotian.Feng@windriver.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 5, 2009, at 9:01 PM, Xiaotian Feng wrote:

>  After UART interrupt handler is installed and rx is enabled, if an rx
> interrupt comes before hardware init, rx->cur will be updated. Then  
> the
> hardware init will reset BD and make rx->cur out of sync, move the  
> hardware
> init code before request_irq.
>
>  Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
> ---
> drivers/serial/cpm_uart/cpm_uart_core.c |   14 ++++++++++++--
> 1 files changed, 12 insertions(+), 2 deletions(-)

applied to next

- k
