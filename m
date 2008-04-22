Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbYDVRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbYDVRIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYDVRI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:08:27 -0400
Received: from mail.ttlc.net ([66.94.32.4]:3161 "EHLO mail.ttlc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbYDVRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:08:26 -0400
Message-ID: <480E19C9.7080807@isomerica.net>
Date: Tue, 22 Apr 2008 13:00:57 -0400
From: Dan Noe <dpn@isomerica.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: config file part of kernel!
References: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
In-Reply-To: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2008 12:53, Sanjeev Aditya Naga wrote:
> Will it be good, if we make the `config` file (used to
> build a kernel) part of the built kernel. So that one in
> need, can extract it from the kernel using some
> userspace tool!?

Enable the CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC option.  It allows 
you to access the active kernel's .config from /proc.

Cheers,
Dan

-- 
Dan Noe (dpn@lampreynetworks.com)
Software Engineer
Lamprey Networks, Inc.
