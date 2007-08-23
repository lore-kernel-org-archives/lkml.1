Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbXHWNeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbXHWNeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbXHWNdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:33:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40331 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572AbXHWNdv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:33:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3-mm1 - irda goes belly up
In-Reply-To: Your message of "Wed, 22 Aug 2007 02:06:48 PDT."
             <20070822020648.5ea3a612.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187876026_3088P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Aug 2007 09:33:46 -0400
Message-ID: <23568.1187876026@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187876026_3088P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

OK, so I don't actually *use* the irDA on my laptop for much, but I figure if
I have the hardware, I should at least make sure the driver comes up.

23-rc3-mm1 causes massive spewage, apparently at least partially as a fall-out
of the sysctl rework.  Not sure if those caused the 'unknown symbol' issues or
not.  The 'cannot allocate memory' is somewhat odd too, I can't believe it was
*really* out of memory while still in /etc/rc5.d when I have 2G of ram...

kernel: [  247.804000] NET: Registered protocol family 23
kernel: [  247.804000] sysctl table check failed: /net/irda .3.412 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/discovery .3.412.1 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/devname .3.412.2 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/debug .3.412.3 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/fast_poll_increase .3.412.4 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/discovery_slots .3.412.5 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/discovery_timeout .3.412.6 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/slot_timeout .3.412.7 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/max_baud_rate .3.412.8 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/min_tx_turn_time .3.412.9 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/max_tx_data_size .3.412.10 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/max_tx_window .3.412.11 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/max_noreply_time .3.412.12 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/warn_noreply_time .3.412.13 Unknown sysctl binary path
kernel: [  247.804000] sysctl table check failed: /net/irda/lap_keepalive_time .3.412.14 Unknown sysctl binary path
kernel: [  247.816000] NET: Unregistered protocol family 23
kernel: [  247.826000] ircomm: Unknown symbol hashbin_insert
kernel: [  247.826000] ircomm: Unknown symbol irttp_flow_request
kernel: [  247.826000] ircomm: Unknown symbol hashbin_lock_find
kernel: [  247.826000] ircomm: Unknown symbol irttp_open_tsap
kernel: [  247.826000] ircomm: Unknown symbol irlmp_connect_request
kernel: [  247.826000] ircomm: Unknown symbol irda_notify_init
kernel: [  247.826000] ircomm: Unknown symbol hashbin_get_first
kernel: [  247.826000] ircomm: Unknown symbol irttp_connect_response
kernel: [  247.827000] ircomm: Unknown symbol irda_debug
kernel: [  247.827000] ircomm: Unknown symbol hashbin_get_next
kernel: [  247.827000] ircomm: Unknown symbol hashbin_remove
kernel: [  247.827000] ircomm: Unknown symbol hashbin_delete
kernel: [  247.827000] ircomm: Unknown symbol hashbin_new
kernel: [  247.827000] ircomm: Unknown symbol irttp_disconnect_request
kernel: [  247.827000] ircomm: Unknown symbol irlmp_disconnect_request
kernel: [  247.827000] ircomm: Unknown symbol irlmp_connect_response
kernel: [  247.827000] ircomm: Unknown symbol irttp_data_request
kernel: [  247.827000] ircomm: Unknown symbol irttp_connect_request
kernel: [  247.827000] ircomm: Unknown symbol irlmp_close_lsap
kernel: [  247.827000] ircomm: Unknown symbol irttp_close_tsap
kernel: [  247.827000] ircomm: Unknown symbol proc_irda
kernel: [  247.827000] ircomm: Unknown symbol irlmp_open_lsap
kernel: [  247.827000] ircomm: Unknown symbol irlmp_data_request
kernel: [  247.829000] ircomm_tty: Unknown symbol irda_param_insert
kernel: [  247.829000] ircomm_tty: Unknown symbol hashbin_insert
kernel: [  247.829000] ircomm_tty: Unknown symbol irlmp_service_to_hint
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_data_request
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_flow_request
kernel: [  247.829000] ircomm_tty: Unknown symbol irias_new_object
kernel: [  247.829000] ircomm_tty: Unknown symbol irlmp_unregister_service
kernel: [  247.829000] ircomm_tty: Unknown symbol hashbin_lock_find
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_open
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_close
kernel: [  247.829000] ircomm_tty: Unknown symbol iriap_open
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_control_request
kernel: [  247.829000] ircomm_tty: Unknown symbol irias_add_octseq_attrib
kernel: [  247.829000] ircomm_tty: Unknown symbol irda_notify_init
kernel: [  247.829000] ircomm_tty: Unknown symbol irlmp_discovery_request
kernel: [  247.829000] ircomm_tty: Unknown symbol iriap_close
kernel: [  247.829000] ircomm_tty: Unknown symbol hashbin_get_first
kernel: [  247.829000] ircomm_tty: Unknown symbol irias_add_integer_attrib
kernel: [  247.829000] ircomm_tty: Unknown symbol ircomm_connect_request
kernel: [  247.829000] ircomm_tty: Unknown symbol irda_debug
kernel: [  247.830000] ircomm_tty: Unknown symbol irlmp_register_service
kernel: [  247.830000] ircomm_tty: Unknown symbol irda_param_extract_all
kernel: [  247.830000] ircomm_tty: Unknown symbol hashbin_get_next
kernel: [  247.830000] ircomm_tty: Unknown symbol ircomm_disconnect_request
kernel: [  247.830000] ircomm_tty: Unknown symbol hashbin_delete
kernel: [  247.830000] ircomm_tty: Unknown symbol hashbin_new
kernel: [  247.830000] ircomm_tty: Unknown symbol irlmp_register_client
kernel: [  247.830000] ircomm_tty: Unknown symbol iriap_getvaluebyclass_request
kernel: [  247.830000] ircomm_tty: Unknown symbol irias_insert_object
kernel: [  247.830000] ircomm_tty: Unknown symbol ircomm_connect_response
kernel: [  247.830000] ircomm_tty: Unknown symbol irias_delete_object
kernel: [  247.830000] ircomm_tty: Unknown symbol irlmp_unregister_client
kernel: [  247.830000] ircomm_tty: Unknown symbol irda_param_pack
kernel: [  247.830000] ircomm_tty: Unknown symbol irias_delete_value
kernel: [  247.850000] NET: Registered protocol family 23
kernel: [  247.850000] sysctl table check failed: /net/irda .3.412 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/discovery .3.412.1 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/devname .3.412.2 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/debug .3.412.3 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/fast_poll_increase .3.412.4 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/discovery_slots .3.412.5 Unknown sysctl binary path
kernel: [  247.850000] sysctl table check failed: /net/irda/discovery_timeout .3.412.6 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/slot_timeout .3.412.7 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/max_baud_rate .3.412.8 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/min_tx_turn_time .3.412.9 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/max_tx_data_size .3.412.10 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/max_tx_window .3.412.11 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/max_noreply_time .3.412.12 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/warn_noreply_time .3.412.13 Unknown sysctl binary path
kernel: [  247.851000] sysctl table check failed: /net/irda/lap_keepalive_time .3.412.14 Unknown sysctl binary path
kernel: [  247.862000] NET: Unregistered protocol family 23
kernel: [  247.867000] sir_dev: Unknown symbol alloc_irdadev
kernel: [  247.867000] sir_dev: Unknown symbol irlap_open
kernel: [  247.868000] sir_dev: Unknown symbol irda_qos_bits_to_value
kernel: [  247.868000] sir_dev: Unknown symbol irda_debug
kernel: [  247.868000] sir_dev: Unknown symbol async_unwrap_char
kernel: [  247.868000] sir_dev: Unknown symbol irlap_close
kernel: [  247.868000] sir_dev: Unknown symbol irda_device_set_media_busy
kernel: [  247.868000] sir_dev: Unknown symbol async_wrap_skb
kernel: [  247.868000] sir_dev: Unknown symbol irda_init_max_qos_capabilies
kernel: [  247.870000] irtty_sir: Unknown symbol sirdev_set_dongle
kernel: [  247.871000] irtty_sir: Unknown symbol irda_debug
kernel: [  247.871000] irtty_sir: Unknown symbol sirdev_write_complete
kernel: [  247.871000] irtty_sir: Unknown symbol sirdev_put_instance
kernel: [  247.871000] irtty_sir: Unknown symbol sirdev_receive
kernel: [  247.871000] irtty_sir: Unknown symbol sirdev_get_instance
kernel: [  247.882000] PPP generic driver version 2.4.2
kernel: [  247.900000] NET: Registered protocol family 23
kernel: [  247.900000] sysctl table check failed: /net/irda .3.412 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/discovery .3.412.1 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/devname .3.412.2 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/debug .3.412.3 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/fast_poll_increase .3.412.4 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/discovery_slots .3.412.5 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/discovery_timeout .3.412.6 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/slot_timeout .3.412.7 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/max_baud_rate .3.412.8 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/min_tx_turn_time .3.412.9 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/max_tx_data_size .3.412.10 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/max_tx_window .3.412.11 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/max_noreply_time .3.412.12 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/warn_noreply_time .3.412.13 Unknown sysctl binary path
kernel: [  247.900000] sysctl table check failed: /net/irda/lap_keepalive_time .3.412.14 Unknown sysctl binary path
kernel: [  247.911000] NET: Unregistered protocol family 23
kernel: [  247.917000] irnet: Unknown symbol hashbin_insert
kernel: [  247.917000] irnet: Unknown symbol irlmp_service_to_hint
kernel: [  247.917000] irnet: Unknown symbol hashbin_remove_this
kernel: [  247.917000] irnet: Unknown symbol irias_new_object
kernel: [  247.917000] irnet: Unknown symbol irlmp_unregister_service
kernel: [  247.918000] irnet: Unknown symbol irlmp_update_client
kernel: [  247.918000] irnet: Unknown symbol irttp_open_tsap
kernel: [  247.918000] irnet: Unknown symbol iriap_open
kernel: [  247.918000] irnet: Unknown symbol irda_notify_init
kernel: [  247.918000] irnet: Unknown symbol iriap_close
kernel: [  247.918000] irnet: Unknown symbol hashbin_get_first
kernel: [  247.919000] irnet: Unknown symbol irias_add_integer_attrib
kernel: [  247.919000] irnet: Unknown symbol irttp_dup
kernel: [  247.919000] irnet: Unknown symbol irttp_connect_response
kernel: [  247.919000] irnet: Unknown symbol irlmp_register_service
kernel: [  247.919000] irnet: Unknown symbol hashbin_get_next
kernel: [  247.919000] irnet: Unknown symbol hashbin_delete
kernel: [  247.920000] irnet: Unknown symbol hashbin_new
kernel: [  247.920000] irnet: Unknown symbol irttp_disconnect_request
kernel: [  247.920000] irnet: Unknown symbol hashbin_find
kernel: [  247.920000] irnet: Unknown symbol irlmp_register_client
kernel: [  247.920000] irnet: Unknown symbol iriap_getvaluebyclass_request
kernel: [  247.920000] irnet: Unknown symbol irias_insert_object
kernel: [  247.921000] irnet: Unknown symbol irias_delete_object
kernel: [  247.921000] irnet: Unknown symbol irttp_data_request
kernel: [  247.921000] irnet: Unknown symbol irttp_connect_request
kernel: [  247.921000] irnet: Unknown symbol irttp_close_tsap
kernel: [  247.921000] irnet: Unknown symbol proc_irda
kernel: [  247.921000] irnet: Unknown symbol irlmp_unregister_client
kernel: [  247.922000] irnet: Unknown symbol irias_delete_value
kernel: [  247.922000] irnet: Unknown symbol irlmp_get_discoveries
irattach: tcgetattr: Input/output error
irattach: Stopping device /dev/ttyS2
kernel: [  247.972000] NET: Registered protocol family 23
kernel: [  247.972000] sysctl table check failed: /net/irda .3.412 Unknown sysctl binary path
kernel: [  247.972000] sysctl table check failed: /net/irda/discovery .3.412.1 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/devname .3.412.2 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/debug .3.412.3 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/fast_poll_increase .3.412.4 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/discovery_slots .3.412.5 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/discovery_timeout .3.412.6 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/slot_timeout .3.412.7 Unknown sysctl binary path
kernel: [  247.973000] sysctl table check failed: /net/irda/max_baud_rate .3.412.8 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/min_tx_turn_time .3.412.9 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/max_tx_data_size .3.412.10 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/max_tx_window .3.412.11 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/max_noreply_time .3.412.12 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/warn_noreply_time .3.412.13 Unknown sysctl binary path
kernel: [  247.974000] sysctl table check failed: /net/irda/lap_keepalive_time .3.412.14 Unknown sysctl binary path
kernel: [  247.984000] NET: Unregistered protocol family 23
modprobe: FATAL: Error inserting irda (/lib/modules/2.6.23-rc3-mm1/kernel/net/irda/irda.ko): Cannot allocate memory
irattach: socket(AF_IRDA): Address family not supported by protocol
irattach: exiting ...


--==_Exmh_1187876026_3088P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGzYy6cC3lWbTT17ARAs8VAKCEVX6chQDKwavl98a2eJzSF4Nq/QCg+GrK
oICm4WHhzE0iXPPO47jzZqU=
=Ia9V
-----END PGP SIGNATURE-----

--==_Exmh_1187876026_3088P--
