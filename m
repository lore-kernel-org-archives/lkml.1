Return-Path: <linux@dominikbrodowski.net>
Date: Wed, 12 Nov 2008 11:17:25 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        alan@redhat.com
Subject: [git pull] PCMCIA updates and fixes for 2.6.28-rc4
Message-ID: <20081112101725.GA14698@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	alan@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-OfflineIMAP-x558136407-6973696c6d61722e6d61696c-6c696e75782d73656e74: 1225
	241620-0981316510871-v4.0.13
X-Mailing-List: linux-kernel@vger.kernel.org
User-Agent: Mutt/1.5.18 (2008-05-17)

Linus,

a few PCMCIA bugfixes are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

The diffstat and list of changes follows, the individual diffs are sent (at
least) to the linux-pcmcia list.

Thanks,
	Dominik

----

Dominik Brodowski (2):
      pcmcia: add braces in error path
      pcmcia: ensure correct logging in do_io_probe

Ilpo Järvinen (1):
      pcmcia: fix indentation & braces disagreement - add braces

Kay Sievers (1):
      pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()

Komuro (1):
      pcmcia: setup resource information for pseudo multifunction devices.

Marc Pignat (1):
      pcmcia: add another pata/ide ID

 drivers/ata/pata_pcmcia.c        |    1 +
 drivers/ide/ide-cs.c             |    1 +
 drivers/pcmcia/cistpl.c          |    3 ++-
 drivers/pcmcia/cs.c              |   14 +++++++-------
 drivers/pcmcia/ds.c              |   11 ++++++-----
 drivers/pcmcia/pcmcia_resource.c |    3 ++-
 drivers/pcmcia/rsrc_nonstatic.c  |    6 +++---
 7 files changed, 22 insertions(+), 17 deletions(-)
