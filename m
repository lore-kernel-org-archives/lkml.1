Return-Path: <linux-kernel-owner+w=401wt.eu-S967093AbXFGXk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967093AbXFGXk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763659AbXFGXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:40:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:44657 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934798AbXFGXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R1zUkHM5USDO4D9oagS/xVVLllpHUYOlhvVYcvC7qJTzJGyl7Z5ct/rzM9p+L8aQjy6wk6o6OtkSYwROKHA4/1UzkSPLJOK2ebVnZCxtZqita1QAcML+eU+8Po7uyU5rRk77kKhXm/cqouWqzeKIecvzA0ATCERYG2x/QKZyDZc=
Message-ID: <9a8748490706071640m4726c39ch1bba246386681ead@mail.gmail.com>
Date: Fri, 8 Jun 2007 01:40:18 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Some ATARI config option confusion
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI

I just finished configuring my freshly git pull'ed kernel source and
then when I started building it some ATARI related config symbols
yelled at me :(

$ make -j 3
scripts/kconfig/conf -s arch/i386/Kconfig
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
