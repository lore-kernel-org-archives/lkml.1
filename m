Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYIQINO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYIQINO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYIQINB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:13:01 -0400
Received: from re01.intra2net.com ([82.165.28.202]:48905 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYIQIM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:12:59 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: RFC: [patch] log fatal signals like SIGSEGV
Date: Wed, 17 Sep 2008 10:12:55 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.25.14-108.fc9.i686; KDE/4.1.1; i686; ; )
References: <200809121502.15264.thomas.jarosch@intra2net.com> <200809161459.17750.thomas.jarosch@intra2net.com> <20080916174202.GA5703@joi>
In-Reply-To: <20080916174202.GA5703@joi>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171012.55758.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16. September 2008 19:42:17 you wrote:
> It looks much better now. But I don't think it will go in as is.
> Maybe you can disable it by default and create a sysctl switch?

The idea is to enable it by default :-) Normally you shouldn't see -any- 
output except for broken hardware/software. That's something you want to get 
notified about and be able to trace back later on.

I guess it might be a good idea to make the SIGKILL output optional via sysctl 
and disabled by default as this could trigger during normal system operation
("Sending all processes the KILL signal" during shutdown). Would that be ok?

Thomas

