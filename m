Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbZCXQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbZCXQWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760422AbZCXQWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:22:15 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:61072 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZCXQWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <49C9046A.6060708@petalogix.com>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	 <d3f49195b8f675db48d2eda4f09fddb51af6f946.1237407249.git.monstr@monstr.eu>
	 <34c2f9e50610e147be556607e482b88fd674b887.1237407249.git.monstr@monstr.eu>
	 <15f6f10873f7c6f4f3b06f9d4d5af3ee9714f873.1237407249.git.monstr@monstr.eu>
	 <e5b88f50c39aa95431f5ecdb032c6676399ae198.1237407249.git.monstr@monstr.eu>
	 <50253611a0770c1ae6a63702208cfb9f96cd1f1a.1237407249.git.monstr@monstr.eu>
	 <28a81149bf51571cbc898a672efff4770fbc1efe.1237407249.git.monstr@monstr.eu>
	 <55868bc389e07d10d00e92a1da65f31256a26f4c.1237407249.git.monstr@monstr.eu>
	 <57d096a05c22f5b3dd1070e9ecd6e8e05b22e9b3.1237407249.git.monstr@monstr.eu>
	 <49C9046A.6060708@petalogix.com>
Date: Wed, 25 Mar 2009 02:22:10 +1000
Message-ID: <1d3f23370903240922l38a8ce1ayb43ccdab52f89a21@mail.gmail.com>
Subject: Re: [PATCH 57/57] microblaze_v7: Uartlite for Microblaze
From: John Williams <john.williams@petalogix.com>
To: michal.simek@petalogix.com
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 2:03 AM, Michal Simek
<michal.simek@petalogix.com> wrote:


>>  config SERIAL_OF_PLATFORM
>>       tristate "Serial port on Open Firmware platform bus"
>> -     depends on PPC_OF
>> +     depends on PPC_OF || MICROBLAZE
>>       depends on SERIAL_8250 || SERIAL_OF_PLATFORM_NWPSERIAL
>>       help
>>         If you have a PowerPC based system that has serial ports

Trivial tweak - update the help text to "PowerPC or MicroBlaze"

John
