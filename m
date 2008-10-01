Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYJALHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYJALHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJALHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:07:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYJALHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Lr5LaXXP5lteeahSaz8n1cYR63eaOjxy11lL6Pw0HPtxUbyS0EMPu2/biiFsdQLRVu
         8dp3fH3wjtlLk52UNymXlNNCYbjjXv2qBqFql43XEe+eiPf5kG483gcDLSI/UGO+UzfY
         JZ1jAMn7ahzmDE4fQwGVmj2Yzl51mRkwTmZr8=
Message-ID: <48E359F3.8030109@gmail.com>
Date: Wed, 01 Oct 2008 13:07:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Vegard Nossum <vegardno@ifi.uio.no>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com>
In-Reply-To: <48E359B4.7050708@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, and thanks for spotting this!

On 10/01/2008 01:06 PM, Jiri Slaby wrote:
> On 10/01/2008 12:47 PM, Vegard Nossum wrote:
>> Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y

