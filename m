Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYDXL2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYDXL2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYDXL16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:27:58 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3086 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYDXL16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:27:58 -0400
To: "Shigeo N" <shigeonx@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: XTP for 2.6.25
From: Andi Kleen <andi@firstfloor.org>
References: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
Date: Thu, 24 Apr 2008 13:27:54 +0200
In-Reply-To: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com> (Shigeo N.'s message of "Thu, 24 Apr 2008 19:14:38 +0900")
Message-ID: <873apbijb9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 11:21:04.0863 (UTC) FILETIME=[48E97EF0:01C8A5FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Shigeo N" <shigeonx@gmail.com> writes:
>
> I tested in the network where UDP throughput is 29Mbps, then TCP
> throughput was 13Mbps, but XTP's reached to 25Mbps.

One interesting question is why TCP was so much slower than UDP
on your test. It shouldn't be on a fair test setup. 

Please post details. Was the network losing packets?

New protocols might be interesting, but even more interesting is to
fix any (real) problems in existing protocols.

-Andi
