Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbXJVKc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbXJVKc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXJVKcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:32:52 -0400
Received: from relay4.usu.ru ([194.226.235.39]:40742 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbXJVKcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:32:51 -0400
Message-ID: <471C7C33.4090003@ums.usu.ru>
Date: Mon, 22 Oct 2007 16:32:19 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se> <20071022101107.GA20690@infradead.org>
In-Reply-To: <20071022101107.GA20690@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Oct 20, 2007 at 02:42:38PM +0200, Henrik Carlqvist wrote:
>> I think there is a need for Kconfig to specify that a functionality could
>> be built as a module or not built at all.
>>
>> Some drivers require that firmware is loaded when the driver is
>> initialized. The kernel has functionalities for this by using a userspace
>> program. However, this userspace program is only usable from modules and
>> not during boot while any initrd or any other file system has not yet been
>> mounted and yet less any processes started.
> 
> That's wrong.   You can load firmware from the initramfs even if the
> driver is built in.  There is no valid reason why a driver shouldn't
> be allowed to be built in.

Could you please explain how this is supposed to work?

As far as I understand, the kernel initializes all built-in drivers, and 
only then starts /init in initramfs (which is then supposed to start 
udevd and load firmware) - but that's too late.

-- 
Alexander E. Patrakov
