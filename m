Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYGaVmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYGaVmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYGaVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:42:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013AbYGaVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:42:28 -0400
Date: Thu, 31 Jul 2008 14:41:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 process time accounting
Message-Id: <20080731144147.82fcd85e.akpm@linux-foundation.org>
In-Reply-To: <20080731104319.GB5806@ics.muni.cz>
References: <20080731104319.GB5806@ics.muni.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 12:43:19 +0200
Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> Hello,
> 
> I think there is a regression since 2.6.26 in time accounting of processes.

Could be - we changed quite a bit.

> kthreadd and console-kit-daemons claim they spent 5124095 hours using CPU.

My 2.6.27-rc1-mm1 kthreadd looks OK in `top'.  How are you displaying
this information?  More details if possible, please..
