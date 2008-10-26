Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYJZWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYJZWLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJZWLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:11:25 -0400
Received: from mx0.towertech.it ([213.215.222.73]:53606 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752463AbYJZWLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:11:24 -0400
Date: Sun, 26 Oct 2008 23:11:12 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: ds3234 doesn't link when built-in
Message-ID: <20081026231112.6ec4bf56@i1501.lan.towertech.it>
In-Reply-To: <Pine.LNX.4.64.0810261518010.15317@anakin>
References: <Pine.LNX.4.64.0810261518010.15317@anakin>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 15:19:20 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> When ds3234 is built-in, the final links fails with the following vague error
> message:
> 
> `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> 
> ds3234_remove() cannot be marked __exit, as it's accessed via __devexit_p().
> In addition, mark ds3234_probe() __devinit while we're at it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

