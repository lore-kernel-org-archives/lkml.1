Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYDNTQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYDNTQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYDNTP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:15:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYDNTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:15:59 -0400
Date: Mon, 14 Apr 2008 12:11:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: valid task structure and wake_up_process
Message-ID: <20080414121105.5f9e5482@laptopd505.fenrus.org>
In-Reply-To: <4a4634330804141136xcaf098esf02539bf76917781@mail.gmail.com>
References: <4a4634330804141136xcaf098esf02539bf76917781@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 13:36:42 -0500
"Shirish Pargaonkar" <shirishpargaonkar@gmail.com> wrote:

> How do I check whether a task is valid before calling
> wake_up_process() with that task structure pointer?

Hi,

how did you get the pointer you got?

That part (the guy who gave you the pointer) should have taken a reference on the task basically,
or otherwise locked against the task going away.

In giving you advice it would help tremendously if you actually posted your code...





-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
