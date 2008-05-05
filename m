Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbYEETEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbYEETEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbYEETDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:03:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:39846 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763315AbYEETC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QbP6/9kVZ5ZK6nJlIaMFry/qP4lRbGmzMWM7y8j4SdjrSKx/wO3O9soOPNNRzCm6Fw02g6UE2YhQJZmsOovmsxPnkQgw9+jLVMcC2+h3cXlDLq3tI/YDNARQdub6ZlieK/FdmLUOUnT1eyoIWLIYPyXkMbwpvdNy9LOTW7hDH+c=
Message-ID: <52950c3f0805051058t5d3447c2r3ae8e77cf0166b00@mail.gmail.com>
Date: Mon, 5 May 2008 13:58:59 -0400
From: "Timur Alperovich" <timur.alperovich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: exported version of page_is_ram?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to check if a given page is in ram or not. It seems that
page_is_ram does the trick, but since it's not exported, I end up with
"unknown symbol" errors when I try to insert the module. I'm trying to
hash the contents of every page in physical memory, and iterating
through pages from 0 to num_physpages, while checking if they are
actually in ram seemed reasonable. Is there a better way to do it or
is there another function rather than page_is_ram that can do the
trick?

Thank you,
Timur
