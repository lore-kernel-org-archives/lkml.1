Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbXJPKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbXJPKvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXJPKvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:51:12 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:55087 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbXJPKvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:51:10 -0400
Message-ID: <4714979C.5010103@free.fr>
Date: Tue, 16 Oct 2007 12:51:08 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr>
In-Reply-To: <471342C8.2030305@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> Alexey Starikovskiy wrote:
>
>> Could you please open bug at bugzilla.kernel.org and put all these
>> files there?
>
> http://bugzilla.kernel.org/show_bug.cgi?id=9148
> 
> Writing 15361 (i.e. 0x3C01) to ACPI_REGISTER_PM1A_CONTROL appears to
> hang my system in acpi_os_write_port(). What can I do about that?

Another observation: if I connect a screen to the system's VGA port, 
when I call 'poweroff' the screen goes into power saving mode. This 
seems to indicate that the integrated video card is properly shut down.

So the fans keep spinning, the LEDs keep shining, the LCD keeps 
displaying, but the video card is shut down?

Might this help pinpoint the problem?

Regards.
