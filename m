Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYDJQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYDJQF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbYDJQE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:04:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbYDJQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:04:59 -0400
Message-ID: <47FE3985.2060001@zytor.com>
Date: Thu, 10 Apr 2008 09:00:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com> <47FE0906.8080102@fr.ibm.com>
In-Reply-To: <47FE0906.8080102@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> 
> OK. I didn't know that. I took sys_llseek() as an example of an interface 
> to follow when coded clone64(). 
> 

llseek() was the first system call that took a doublewidth argument. 
It's not the one you want to mimic.

	-hpa
