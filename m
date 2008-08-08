Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYHHIBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYHHIBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYHHIBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:01:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:55590 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYHHIBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lw6amoIcI9ZgmyIqjZe3mq7hIluatMDEAusNCL/4kh35ZbPsXwyhbWgA2yw6IarTqQ
         wuokw8PnMUassit8e1WJ8yzDF5jdRT2T/Nh7goc6GnjAXkR6SvmuPdgHeteRtyvovBRI
         OEdEg+8wGmdKf21f9ZOl5pry5yOqxp+ow0Y0w=
Message-ID: <38b2ab8a0808080101v795327f0n9da5adb33a3c1a9@mail.gmail.com>
Date: Fri, 8 Aug 2008 10:01:13 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mm@vger.kernel.org
Subject: question about do_anonymous_page()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm wondering why do_anonymous_page() calls lru_cache_add_active(page)
where page does not belong to the page cache ?

Is it simply because lru_add_active() doesn't exist ?

Thanks
-- 
Francis
