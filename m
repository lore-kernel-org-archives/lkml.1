Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYGEJv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYGEJv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYGEJvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:51:50 -0400
Received: from il.qumranet.com ([212.179.150.194]:49143 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYGEJvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:51:50 -0400
Message-ID: <486F4431.8000804@qumranet.com>
Date: Sat, 05 Jul 2008 12:51:45 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: [PATCH] KVM: SVM: fix suspend/resume support
References: <1215007331-1121-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1215007331-1121-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On suspend the svm_hardware_disable function is called which frees all svm_data
> variables. On resume they are not re-allocated. This patch removes the
> deallocation of svm_data from the hardware_disable function to the
> hardware_unsetup function which is not called on suspend.
>
>   

Applied, thanks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

