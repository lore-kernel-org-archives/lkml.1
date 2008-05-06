Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbYEFWh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbYEFWh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbYEFWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:37:26 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:53884 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbYEFWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:37:22 -0400
Message-ID: <4820DDA0.1030100@isomerica.net>
Date: Tue, 06 May 2008 18:37:20 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Adrian Sud <pigsflew2008@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Parsing Structures postmortem from memory dump
References: <4820ABA5.3020705@gmail.com>
In-Reply-To: <4820ABA5.3020705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Sud wrote:
> I've looked at /include/linux/sched.h and tried to understand the 
> task_struct structure, but it appears to be variable-length, determined 
> at compile time, and I can't tell exactly how these are stored 
> throughout memory--In a list? a tree?

The task_struct structures are stored on one or more lists.  Note the 
list_head types within the structure - each of this is a list that the 
structure is (potentially) a member of.

This is a good explanation of how the kernel's lists work:

http://kernelnewbies.org/FAQ/LinkedLists

I don't know if a generalized printer/parser exists for the kernel 
linked list, but this might be a good way to start exploring your 
project.  There are macros to traverse the lists easily, so it shouldn't 
be too difficult.

Hope that helps.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noé
                     |  http://isomerica.net/~dpn/
