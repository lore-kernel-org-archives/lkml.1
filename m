Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXFSHo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXFSHo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXFSHoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:44:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:35179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXFSHoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OeMiGlWG6HapkX18qHhTPhJMQxyUrYi4pIPqaz1Cuj6w91Yez1yCG/B8r3kG3R/wMJ8phEARN2JmZKsDf9cL8H0hAK+dKrX60GRbOWS1qwCGOsYS56dXk8jE/vMu/y3fDJ/ldI6KW8q0iFIzwhH6cvACVpuWq6rvQ1n/4grN5Ec=
Message-ID: <46778958.2040903@gmail.com>
Date: Tue, 19 Jun 2007 09:44:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Thierry Merle <thierry.merle@free.fr>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz> <466131CB.20301@free.fr> <6872422218943432279_1@wsc.cz> <200706190941.47459.oliver@neukum.org>
In-Reply-To: <200706190941.47459.oliver@neukum.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum napsal(a):
> Am Freitag, 15. Juni 2007 schrieb Jiri Slaby:
>> +struct stk11xx_frame_buf {
>> +       void *data;
>> +       volatile int filled;
>> +       struct stk11xx_frame_buf *next;
>> +};
>> +
> 
> What's the "volatile" doing here?

removed (s/volatile/unsigned/), thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
