Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbXGaUrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbXGaUrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbXGaUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:47:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43439 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbXGaUrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:47:32 -0400
Date: Tue, 31 Jul 2007 22:48:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings
Message-ID: <20070731204846.GA9985@uranus.ravnborg.org>
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF9152.2050707@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 09:45:22PM +0200, Gabriel C wrote:
> Hi Sam ,
> 
> me again. I got some more mismatch warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-14 )
> 
> 
> ...
> 
> 
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x8adb): Section mismatch: reference to .init.text:register_cpu (between 'arch_register_cpu' and 'text_poke')
> WARNING: vmlinux.o(.text+0xb790c): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')
They need further analysis.

> WARNING: vmlinux.o(.text+0x12f01e): Section mismatch: reference to .init.text:mlx4_init_one (between 'mlx4_restart_one' and 'mlx4_cleanup_mcg_table')
> WARNING: vmlinux.o(.text+0x1dd831): Section mismatch: reference to .init.text:setup_TeleInt (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dd9e7): Section mismatch: reference to .init.text:setup_elsa (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dd9f8): Section mismatch: reference to .init.text:setup_avm_a1 (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda08): Section mismatch: reference to .init.text:setup_teles0 (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda18): Section mismatch: reference to .init.text:setup_netjet_u (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda28): Section mismatch: reference to .init.text:setup_hfcpci (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda38): Section mismatch: reference to .init.text:setup_saphir (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda48): Section mismatch: reference to .init.text:setup_avm_pcipnp (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda58): Section mismatch: reference to .init.text:setup_s0box (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda68): Section mismatch: reference to .init.text:setup_telespci (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda78): Section mismatch: reference to .init.text:setup_netjet_s (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1dda88): Section mismatch: reference to .init.text:setup_hfcs (between 'checkcard' and 'hisax_init_pcmcia')
> WARNING: vmlinux.o(.text+0x1f4e96): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'inithscxisac' and 'open_hscxstate')
> WARNING: vmlinux.o(.text+0x1f4ea4): Section mismatch: reference to .init.text:initisac (between 'inithscxisac' and 'open_hscxstate')
> WARNING: vmlinux.o(.text+0x1fa774): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'AVM_card_msg' and 'avm_pcipnp_interrupt')
> WARNING: vmlinux.o(.text+0x1fa77b): Section mismatch: reference to .init.text:initisac (between 'AVM_card_msg' and 'avm_pcipnp_interrupt')
> WARNING: vmlinux.o(.text+0x1fdbbf): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'TeleInt_card_msg' and 'WriteHFC')
> WARNING: vmlinux.o(.text+0x1fdbc6): Section mismatch: reference to .init.text:initisac (between 'TeleInt_card_msg' and 'WriteHFC')
> WARNING: vmlinux.o(.text+0x1ff98f): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'NETjet_S_card_msg' and 'netjet_s_interrupt')
> WARNING: vmlinux.o(.text+0x1ff996): Section mismatch: reference to .init.text:initisac (between 'NETjet_S_card_msg' and 'netjet_s_interrupt')
ISDN stuff can wait until Karsten and Jeff has finished the ongoing transition to the
new PCI API.

> WARNING: vmlinux.o(.text+0x2d6a77): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
> WARNING: vmlinux.o(.text+0x2d6aa1): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
> WARNING: vmlinux.o(.text+0x2d6abd): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
> WARNING: vmlinux.o(.text+0x2d994a): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'alc880_parse_auto_config' and 'alc882_gpio_mute')
> WARNING: vmlinux.o(.text+0x2da2fe): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc268' and 'patch_alc662')
> WARNING: vmlinux.o(.text+0x2da31c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc268' and 'patch_alc662')
> WARNING: vmlinux.o(.text+0x2da6e8): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc662' and 'alc_mux_enum_info')
> WARNING: vmlinux.o(.text+0x2da7b5): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc662' and 'alc_mux_enum_info')
> WARNING: vmlinux.o(.text+0x2dae6a): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc880' and 'patch_alc260')
> WARNING: vmlinux.o(.text+0x2db036): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc260' and 'patch_alc882')
> WARNING: vmlinux.o(.text+0x2db0cc): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc260' and 'patch_alc882')
> WARNING: vmlinux.o(.text+0x2db4b0): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc882' and 'patch_alc883')
> WARNING: vmlinux.o(.text+0x2db77a): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc883' and 'patch_alc262')
> WARNING: vmlinux.o(.text+0x2db8ea): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc262' and 'patch_alc861')
> WARNING: vmlinux.o(.text+0x2db9b7): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc262' and 'patch_alc861')
> WARNING: vmlinux.o(.text+0x2dbca6): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861' and 'patch_alc861vd')
> WARNING: vmlinux.o(.text+0x2dbd3c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861' and 'patch_alc861vd')
> WARNING: vmlinux.o(.text+0x2dc0c6): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
> WARNING: vmlinux.o(.text+0x2dc195): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
> WARNING: vmlinux.o(.text+0x2dc77d): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
> WARNING: vmlinux.o(.text+0x2dc796): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
> WARNING: vmlinux.o(.text+0x2dc7c6): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
> WARNING: vmlinux.o(.text+0x2dc7e6): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
> WARNING: vmlinux.o(.text+0x2dc93e): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
> WARNING: vmlinux.o(.text+0x2dcab4): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
> WARNING: vmlinux.o(.text+0x2dd301): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
> WARNING: vmlinux.o(.text+0x2dd32b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
> WARNING: vmlinux.o(.text+0x2dd347): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
> WARNING: vmlinux.o(.text+0x2ddbad): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1984' and 'patch_ad1882')
> WARNING: vmlinux.o(.text+0x2ddcfb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1882' and 'ad198x_free')
> WARNING: vmlinux.o(.text+0x2de7db): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1986a' and 'patch_ad1983')
> WARNING: vmlinux.o(.text+0x2deabb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1981' and 'patch_ad1988')
> WARNING: vmlinux.o(.text+0x2debfd): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
> WARNING: vmlinux.o(.text+0x2dede6): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
> WARNING: vmlinux.o(.text+0x2e00dc): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e0105): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e012f): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e014b): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e06cf): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'stac92xx_parse_auto_config' and 'patch_stac9872')
> WARNING: vmlinux.o(.text+0x2e0e79): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9872' and 'vaio_master_sw_put')
> WARNING: vmlinux.o(.text+0x2e11dc): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9200' and 'patch_stac925x')
> WARNING: vmlinux.o(.text+0x2e1251): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_stac9200' and 'patch_stac925x')
> WARNING: vmlinux.o(.text+0x2e15bb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac925x' and 'patch_stac922x')
> WARNING: vmlinux.o(.text+0x2e172c): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac922x' and 'patch_stac927x')
> WARNING: vmlinux.o(.text+0x2e195f): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac927x' and 'patch_stac9205')
> WARNING: vmlinux.o(.text+0x2e1aef): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9205' and 'si3054_switch_info')
> WARNING: vmlinux.o(.text+0x2e2116): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'si3054_build_controls' and 'patch_si3054')
> WARNING: vmlinux.o(.text+0x2e2248): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'atihdmi_build_controls' and 'patch_atihdmi')
> WARNING: vmlinux.o(.text+0x2e2c51): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
> WARNING: vmlinux.o(.text+0x2e2c7b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
> WARNING: vmlinux.o(.text+0x2e2c97): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
> WARNING: vmlinux.o(.text+0x2e2d99): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5047' and 'cxt5047_hp_automic')
> WARNING: vmlinux.o(.text+0x2e3329): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5045' and 'via_build_pcms')
> WARNING: vmlinux.o(.text+0x2e3617): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'via_build_controls' and 'via_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e3641): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'via_build_controls' and 'via_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e365d): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'via_build_controls' and 'via_mux_enum_put')
> WARNING: vmlinux.o(.text+0x2e3ab3): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'vt1709_parse_auto_config' and 'patch_vt1709_6ch')
> WARNING: vmlinux.o(.text+0x2e429d): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_vt1708' and 'patch_vt1709_10ch')
All the hda_preset stuff should be marked __devinit as far as I can see.
Care to give that a spin yourself? 

> WARNING: vmlinux.o(.data+0xacb10): Section mismatch: reference to .init.text:snd_ad1889_probe (between 'ad1889_pci' and 'ops.20707')
> WARNING: vmlinux.o(.text+0x12f014): Section mismatch: reference to .exit.text:mlx4_remove_one (between 'mlx4_restart_one' and 'mlx4_cleanup_mcg_table')
Did not look at these two yet.

> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
> WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
> WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
When a function is marked __exit and used from an init function then the safe choice
is to just remove the __exit marking. Usually this is small functions used
only in error situations.
Should be trivial too.

Sorry - no patch this time. Could you try to look at it yorself then I will review.

	Sam
