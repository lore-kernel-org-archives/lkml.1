Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0CIUGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:06:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0CIUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:06:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 1/3] input: remove BKL from mousedev
Date: Tue, 9 Mar 2010 21:05:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092105.55102.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/86HnydA6IorwdTX9oaKXbdwjrz3NGIp9YkNo
 tQnn1b/Q0jL27sSLlvZocnh44Yl3GJsYDNh2B3dADZJx8kUJce
 PSdoZ8qhuEm1mCDRW8iBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
> There's no need for BKL in mousedev. It uses lots of locking already
> that should handle the open case.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I actually have the same ones in
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=shortlog;h=refs/heads/bkl-removal
(yes, that's broken), so I'd really like to see them go in.

	Arnd
