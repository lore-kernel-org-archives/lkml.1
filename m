Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZIMVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZIMVMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZIMVMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:12:45 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:33813 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZIMVMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JbVNHI8Z9ydE+OqlBr036ErYumFKa+LgWgrzH5avbPDhOEQWxJYrgVyxUnyPQEpona
         V9vhpcISxlgG9pFthURsKdql2OwBliLGeQrqrS9hOyU0PpAsxqKVUsffjGCrrUTh4DGs
         Y549qUw32PypFkCrVfTGZxfjcN/70Kme5gz6w=
MIME-Version: 1.0
In-Reply-To: <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-2-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Sep 2009 17:12:28 -0400
Message-ID: <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
> +  if $domain; then

is this really correct ?  i think you meant to use:
[ -n "$domain" ]
-mike
