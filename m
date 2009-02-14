Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZBNUAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZBNUAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZBNUAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:00:37 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:59755 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZBNUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=u+NNhIMRfm/ObYOEoGB2YOuEd2zwzomy4klATQm8InRgSpwOCYS4aJPNl6zd6/Ch5Z
         66rE/wgrTOS+bDDZTxGdB25Vbx7E/1Um5RvAquD0imBiKHvb1gQf/d7lDvCQHrqOaDv0
         X+0aRC0XOFMbm7N2gBSRmn9nDdrXJ1JbGdD3Y=
Message-ID: <499722DF.3020208@googlemail.com>
Date: Sat, 14 Feb 2009 21:00:31 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       linux-kernel@vger.kernel.org
CC: David Woodhouse <dwmw2@infradead.org>
Subject: Re: RFC: install firmware in a kernel-dependent directory
References: <4996B838.2070205@googlemail.com> <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
In-Reply-To: <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Jaswinder Singh Rajput wrote:

> firmware version depends on hardware version not by kernel (software) version.

That means that it shouldn't be delivered with the kernel in the first
place, right? Neither built in nor as a separate file. Maybe that's an
even better solution: distribute it separately.

Which firmware to use is a matter of policy, in my opinion. I may want
to use a modified firmware, for example, and put that into /lib/firmware
where it belongs. But each time I install a new kernel, it will be
replaced with the standard version.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
