Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbXEUVyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbXEUVyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXEUVxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:53:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:44987 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbXEUVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XGe2bh1zlDPocKj7UOuO/d4vm240AEfWy+LbJRhd2AsX/MuHhalnQ9Q5tWwHo3ge6j/dsETfB0/BMjssEuZTlSI/lZXjEb2F4h3AkywQIqNlvSIXIEpvaoM+EAepuqfw+bxelPNyjEz0VNGLTUXYDTDtwg4M91wNXy4EXr74/5Q=
Message-ID: <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com>
Date: Mon, 21 May 2007 23:53:49 +0200
From: Luca <kronos.it@gmail.com>
To: "Rudolf Marek" <r.marek@assembler.cz>
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
Cc: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46520F36.4080006@assembler.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513223329.GA29207@dreamland.darkstar.lan>
	 <46520F36.4080006@assembler.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Rudolf Marek <r.marek@assembler.cz> wrote:
> ATK0110 ATK0110:00: atk_enumerate_fan: invalid fan count 3 (should be 5)
> ATK0110: probe of ATK0110:00 failed with error -22

Ok, the FAN package contains 5 items, but the enumerator only
advertises the first 3. I guess that the other 2 (chipset fan and
chassis2 fan) are not usable? Are the connectors for those two fans on
your motherboard? Do you get any reading from them?

Plus: your ACPI code uses the full "magic number" (first item in the
package) to demux the reading, while my board masks the upper 2 bytes;
I need to change the driver. Will send another iteration.

Luca
