Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYJUJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYJUJF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYJUJFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:05:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbYJUJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:05:19 -0400
Message-ID: <48FD9B54.4040109@redhat.com>
Date: Tue, 21 Oct 2008 11:05:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86] - technical questions about HV implementation on Intel
 VT
References: <200810201927.33580.goretux@gmail.com>
In-Reply-To: <200810201927.33580.goretux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> [...]
> So, when the host take control for the first time after the first vmexit, I 
> would like the host to print informations and to "die correctly", so as I 
> could read these information on the screen (ie, without being polluted with 
> lots of debug messages that scroll on the screen).
>   

You should add a serial console or netconsole to your hypervisor; that 
means implementing a serial or network card driver.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

