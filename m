Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753454AbYLQX04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYLQX04 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYLQX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:26:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbYLQX0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:26:46 -0500
Message-ID: <49498AB4.3020500@sgi.com>
Date: Wed, 17 Dec 2008 15:26:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Pull request: merge-x86-12-16
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Would you pull the following?

Thanks!
Mike
--- 
The following changes since commit b77f911294aa099e53af754b9277b34783f629b4:
  Rusty Russell (1):
        x86: Introduce topology_core_cpumask()/topology_thread_cpumask()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git merge-x86-12-16

Mike Travis (2):
      x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
      x86: use possible_cpus=NUM to extend the possible cpus allowed

 Documentation/cpu-hotplug.txt                 |   17 +++++-----
 arch/x86/include/asm/bigsmp/apic.h            |    4 ++-
 arch/x86/include/asm/es7000/apic.h            |   40 +++++++++++-------------
 arch/x86/include/asm/mach-default/mach_apic.h |    3 +-
 arch/x86/include/asm/summit/apic.h            |   30 ++++++++++--------
 arch/x86/kernel/apic.c                        |   16 ++++++----
 arch/x86/kernel/genapic_flat_64.c             |    4 ++-
 arch/x86/kernel/genx2apic_cluster.c           |    4 ++-
 arch/x86/kernel/genx2apic_phys.c              |    4 ++-
 arch/x86/kernel/genx2apic_uv_x.c              |    4 ++-
 arch/x86/kernel/smpboot.c                     |   25 +++++++++++++--
 11 files changed, 92 insertions(+), 59 deletions(-)
