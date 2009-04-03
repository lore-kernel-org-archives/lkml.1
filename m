Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbZDCKQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbZDCKQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZDCKQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:16:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714AbZDCKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:16:35 -0400
Message-ID: <49D5E1EE.6030707@redhat.com>
Date: Fri, 03 Apr 2009 12:16:14 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: Chris Wright <chrisw@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com,
       corbet@lwn.net, yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
References: <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain> <49D4BE64.8020508@redhat.com>
In-Reply-To: <49D4BE64.8020508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> The main problem that ksm will face when removing the fd interface is:
> right now when you register memory into ksm, you open fd, and then ksm
> do get_task_mm(), we will do mmput when the file will be closed

Did you test whenever it really cleans up in case you "kill -9 qemu"?

I recently did something simliar with the result that the extra
reference hold on mm_struct prevented the process memory from being
zapped ...

cheers,
  Gerd
