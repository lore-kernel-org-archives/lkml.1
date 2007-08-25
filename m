Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbXHYL3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbXHYL3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXHYL3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:29:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:48752 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765059AbXHYL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PZecFs6QicGeaU7YZSkDlmnR3cWgRx9jrJU/G7FugA8Doi5Y2DY2aVrSu1CYFmhYUQ2ktcGlgx6CA/+PuX/Jot67qAbffjRioVBIBAj1omeXvNebrvuzkTecvz0jCwwWKxYlMbVSwpDAOfXkTA/QToquGPxpDZCI+fJWrKwpzg0=
Message-ID: <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
Date: Sat, 25 Aug 2007 13:29:38 +0200
From: "David Rodriguez" <livuxman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with CFS V20 and Suspend2/tuxonice
In-Reply-To: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.22.5 with cfs v20.3 and  suspend2  2.2.10.2.
With that combination, suspend is not working anymore (with cfs v19
was working).
Stops on suspend in "Suspending tasks"
Looking at cfs patch, I managed to change the  migration_thread,
adding again the  try_to_freeze() removed in last patch and now the
suspend finished, but resume not work. Of course I don't know why that
was removed, and rewriting it is not a solution, but I want to report
it.

All that in a core duo machine.
