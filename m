Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYKISco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYKISco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYKIScg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:32:36 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:46548 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbYKIScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:32:36 -0500
Message-ID: <49172CA8.5060309@telenet.dn.ua>
Date: Sun, 09 Nov 2008 20:32:08 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua> <20081109183043.GA4530@x200.localdomain>
In-Reply-To: <20081109183043.GA4530@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Nov 09, 2008 at 08:04:45PM +0200, Vitaly V. Bursov wrote:
>> I'm building small server system with openvz kernel and have ran into
>> some IO performance problems. Reading a single file via NFS delivers
>> around 9 MB/s over gigabit network, but while reading, say, 2 different
>> or same file 2 times at the same time I get >60MB/s.
> 
> openvz kernels have very changed CFQ and, IIRC, this one-reader problem is
> fixed somewhere. Ask devel@openvz.org.

That's why I've checked vanilla kernel also. It performs somewhat better,
but definitely shares same issues...

